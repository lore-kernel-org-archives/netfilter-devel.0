From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: Compilation Issue on RG9
Date: Fri, 11 Nov 2005 14:49:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0511111447490.8018@bizon.gios.gov.pl>
References: <5efe1e0b0511110543v7d24c88bmc7c0dd761e502f01@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-873572737-1131716969=:8018"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hai Wang <pppoe.pppoa@gmail.com>
In-Reply-To: <5efe1e0b0511110543v7d24c88bmc7c0dd761e502f01@mail.gmail.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-873572737-1131716969=:8018
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 11 Nov 2005, Hai Wang wrote:

> Hello everyone
Helllo,

> I encountered a problem when I tried to compile iptables-1.3.4 on RH9 (
> 2.4.25), I got the following errors, please shed some lights on it.
>
> ensions/libipt_time_sh.o -c extensions/libipt_time.c
> extensions/libipt_time.c: In function `init':
> extensions/libipt_time.c:66: structure has no member named `date_start'
> extensions/libipt_time.c:67: structure has no member named `date_stop'

Whitch version of patch-o-magic did you use?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-873572737-1131716969=:8018--
