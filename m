From: Patrick McHardy <kaber@trash.net>
Subject: Re: new target: -j TEE
Date: Wed, 29 Aug 2007 21:03:32 +0200
Message-ID: <46D5C304.9040102@trash.net>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>	<Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
	<1188237343.4548.4.camel@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
To: =?ISO-8859-15?Q?Sebastian_Cla=DFen?= <Sebastian.Classen@freenet.ag>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1188237343.4548.4.camel@calypso>
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

Sebastian Cla=DFen wrote:
> Am Montag, den 27.08.2007, 16:21 +0200 schrieb Jan Engelhardt:
>> On Aug 27 2007 14:08, Sebastian Classen wrote:
>>> The ROUTE targe seems to be finaly gone from pom-ng and we need a
>>> solution for the --tee function. So I deciced to use some parts from =
the
>>> ROUTE target, adaped the code to the current kernel and implmemented =
a
>>> new taget called TEE. The only function is packet duplication and tho=
se
>>> duplicate packets are routed the the given gateway (--gw option).
>>>
>>> We use this as a replacement for netwrk traffic taps, the syntax is:
>>> itpables -t mangle -A PREROUTING -p tcp --sport <some-port> -j TEE --=
gw
>>> <IP.of.mirror.box>
>>>
>>> Is there any chance getting this into pom-ng?
>> Here is an updated version first that uses xt:
>>
>> 	http://dev.computergmbh.de/wsvn/misc_kernel/xt_TEE/


Please don't post gzipped patches (Sebastian) or links if the
patch isn't excessively large. I don't look at these things,
and I suspect a lot of others neither.
