From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re[2]: size calculation wasted cpu time
Date: Sat, 25 Jul 2009 09:10:56 +0400
Message-ID: <1412506605.20090725091056@yandex.ru>
References: <152544048.20090316160216@yandex.ru>
 <alpine.LSU.2.00.0907242054530.32211@fbirervta.pbzchgretzou.qr>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward1.yandex.ru ([77.88.46.6]:55803 "EHLO forward1.yandex.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZGYFNx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jul 2009 01:13:53 -0400
In-Reply-To: <alpine.LSU.2.00.0907242054530.32211@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>In /net/netfilter/nfnetlink_queue.c every call of nfqnl_build_packet_message()
>>make series of call nla_total_size() for 'size' calculations.
>>I think 'size' is constant value for kernel build and may be define static
>>variable for this ?
>>
>>        size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
>>                + nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
>>                + nla_total_size(sizeof(u_int32_t))     /* ifindex */
>>                + nla_total_size(sizeof(u_int32_t))     /* ifindex */

JE> The compiler will optimize it out.

Okey. It's easy to test.


=========== 1.c =======================

#include <stdlib.h>
#include <stdio.h>
#define NLA_ALIGNTO             4
#define NLA_ALIGN(len)          (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
#define NLA_HDRLEN              30

static inline int nla_attr_size(int payload)
{
      return NLA_HDRLEN + payload;
}

static inline int nla_total_size(int payload)
{
      return NLA_ALIGN(nla_attr_size(payload));
}

size_t nfqnl_build_packet_message(int len) {
      size_t size;

      size = nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t));     /* mark */

      return size;
};


int main () {
      long i;
      size_t ret;

      int r = 0;
      for (i = 0; i < 100000000; i++) {
            r = rand();
            printf("%d",r);
            ret = nfqnl_build_packet_message(r);
      };
}
======================== end of 1.c ========================

And other case

===================== 2.c =============================

#include <stdlib.h>
#include <stdio.h>

#define NLA_ALIGNTO             4
#define NLA_ALIGN(len)          (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
#define NLA_HDRLEN              30

static inline int nla_attr_size(int payload)
{
      return NLA_HDRLEN + payload;
}

static inline int nla_total_size(int payload)
{
      return NLA_ALIGN(nla_attr_size(payload));
}

size_t size_global = 0; ///// GLOBAL PRECALCULATED VALUE

size_t nfqnl_build_packet_message(int len) {
      size_t size;

      size = size_global;

      return size;
};


int main () {
      long i;
      size_t ret;

      //////// calculations here
      size_global = nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t))     /* ifindex */
            + nla_total_size(sizeof(u_int32_t));     /* mark */

      int r = 0;
      for (i = 0; i < 100000000; i++) {
            r = rand();
            printf("%d",r);
            ret = nfqnl_build_packet_message(r);
      };
}
===========================================

And some tests....


root@bill:/src/1# gcc 1.c
root@bill:/src/1# time ./a.out > /dev/null
real    0m20.253s
user    0m20.209s
sys     0m0.041s

root@bill:/src/1# gcc 2.c
root@bill:/src/1# time ./a.out > /dev/null
real    0m17.030s
user    0m16.988s
sys     0m0.040s

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
Kuzin Andrey  -  kuzinandrey@yandex.ru
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=




