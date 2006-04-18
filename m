From: "David Vogt" <mail@davidvogt.de>
Subject: Fwd: development with queues
Date: Tue, 18 Apr 2006 12:46:16 +0200
Message-ID: <859616420604180346o2706c306wcf7703dc9b7f67e9@mail.gmail.com>
References: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>
	<859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

---------- Forwarded message ----------
From: David Vogt <beunlovable@gmail.com>
Date: 18.04.2006 12:31
Subject: Re: development with queues
To: miguel Angel Vazquez <mikinho21@gmail.com>


Hi,

you can receive the packets using libnetfilter_queue. IP packets to be
precise, thus you can modify everything above layer 3 (IP), which
includes HTTP.

This
  https://svn.netfilter.org/netfilter/trunk/libnetfilter_queue/utils/nfqnl_=
test.c
might be a good start on how to use libnetfilter_queue. Adding a rule
for the packets to be processed with target "-j NFQUEUE --queue-num 0"
sends the packets to your application (that registers for the
appropriate queue number)

David


2006/4/18, miguel Angel Vazquez <mikinho21@gmail.com>:
> Hi all.
>
> we are trying to develop an application which has to reduce some
> headers from an intercepted packet (some HTTP headers in order to
> optimize an UMTS uplink channel).
>
> I have read some howtos and I think it can be possible to do that.
> As i Have understand, the packet remains queued and I can process it
> in user-space or in kernel-space, but I'm not sure about what the
> packet "status" is....it has all the IP and TCP headers?Can I modify
> the HTTP packet??
>
> Thanks mates!
> (sorry for my English)
>
>
