From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: limiting bandwidth using qdisc alone
Date: Tue, 13 Jul 2004 02:05:44 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407122303.i6CN3bMX002899@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0407122348430.23090-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0407122348430.23090-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I want to limit the bandwidth of my outgoing interfaces for all traffic but
do not want to use shapecfg and shaper. My question is that can I use qdisc
instead. As far as my understanding, I just have to specify a qdisc
(preferably HTB) on the interface, limit the bandwidth and allow all traffic
to go through it, without any iptables marking. Is this possible and
efficient way to do what I want? Or does anybody have a better solution for
this?
Regards,

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami

-----Original Message-----
From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Henrik
Nordstrom
Sent: Tuesday, July 13, 2004 12:51 AM
To: Patrick
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: string match patch

On Mon, 12 Jul 2004, Patrick wrote:

> after I patched it I noticed that I dont have any
> new menu point nor do I have CONFIG_IP_NF_MATCH_STRING in my kernel
> config .. the patch pretends to be applied correctly, which I can also
> verify, because the header files are present.

You SHOULD have a new menu entries for the string match..

    dep_tristate '  String match support (EXPERIMENTAL)'
CONFIG_IP_NF_MATCH_STRING $CONFIG_IP_NF_IPTABLES

If you do not, and or else do not have CONFIG_IP_NF_MATCH_STRING defined
in your kernel configuration then the string match won't be build, and 
hence won't work.

Which version of pom-ng are you using?

Regards
Henrik
