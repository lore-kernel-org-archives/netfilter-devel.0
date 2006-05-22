From: Matt Ayres <matta@tektonic.net>
Subject: Re: Re: Panic in ipt_do_table with 2.6.16.13-xen
Date: Mon, 22 May 2006 10:31:48 -0400
Message-ID: <4471CB54.401@tektonic.net>
References: <4468BE70.7030802@tektonic.net>
	<4468D613.20309@trash.net>	<44691669.4080903@tektonic.net>	<Pine.LNX.4.64.0605152331140.10964@d.namei>	<4469D84F.8080709@tektonic.net>	<Pine.LNX.4.64.0605161127030.16379@d.namei>	<446D0A0D.5090608@tektonic.net>	<Pine.LNX.4.64.0605182002330.6528@d.namei>
	<446D0E6D.2080600@tektonic.net> <446D151D.6030307@tektonic.net>
	<4470A6CD.5010501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	James Morris <jmorris@namei.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <xen-devel-bounces@lists.xensource.com>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4470A6CD.5010501@trash.net>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
List-Id: netfilter-devel.vger.kernel.org



Patrick McHardy wrote:
> Matt Ayres wrote:
>> I think I confirmed the NIC is not the source of the problem.  A few of
>> my servers have e100/tulip NIC's due to a bug with the chipset of the
>> on-board TG3 cards firmware and TSO.  These servers that use the
>> e100/tulip drivers also experience the ipt_do_table bug.
> 
> There is an identical report in the netfilter bugzilla, also crashes
> (on x86_64) in ipt_do_table with Xen. I haven't heard anything of
> similar crashes without Xen, so I doubt that the bug is in the
> netfilter code.
> 
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=478

Yep... too coincidental.  I'd say it has _something_ to do with Xen. 
I've been doing different things on my side to try to reduce the 
severity of the problem, but I'd really like to hear what the Xen guys 
have to say about this now..

Thanks,
Matt
