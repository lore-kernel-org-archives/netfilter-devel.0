From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: mss to pmtu clamping partially broken?
Date: Mon, 2 Jul 2007 21:16:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707022113330.25153@bizon.gios.gov.pl>
References: <4684E853.20900@domdv.de>
	<Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
	<4689300C.9050802@domdv.de> <20070702182850.GB14507@ipom.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-2069770357-1183403817=:25153"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org, Andreas Steinmetz <ast@domdv.de>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070702182850.GB14507@ipom.com>
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

---187430788-2069770357-1183403817=:25153
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 2 Jul 2007, Phil Dibowitz wrote:

> On Mon, Jul 02, 2007 at 07:04:12PM +0200, Andreas Steinmetz wrote:
>> Jan Engelhardt wrote:
>>> Do you really need clamping? It's a hack, since TCP should do MSS negot=
iation
>>> itself. (Of course it may happen that some routers are broken.) But usu=
ally not
>>> for incoming packets.
>>
>> You never know when you hit ICMP blackholes, broken routers and other
>> evil things. Better safe than sorry so clamping is the way to go for me.
>
> I encourage you to report PMTUD Blackholes to the MSS Initiative at
> http://www.phildev.net/mss/

Any chances for similar initiative for "SACK vandals"? ;)

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2069770357-1183403817=:25153--
