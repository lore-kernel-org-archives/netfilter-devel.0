From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: Problems using libipq/QUEUE
Date: Wed, 30 Jun 2004 20:03:32 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406301704.i5UH4EMX025110@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0406301857210.12023-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0406301857210.12023-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am simply using the same example in the manpage. The nfmark is being used
within the libipq application program (status = ipq_set_verdict(h,
m->packet_id,
                                                         NF_ACCEPT, 0,
NULL);.

Still it doesn't seem to work
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
From: Henrik Nordstrom [mailto:hno@marasystems.com] 
Sent: Wednesday, June 30, 2004 7:59 PM
To: Muhammad R. Sami
Cc: Netfilter List
Subject: Re: Problems using libipq/QUEUE

On Wed, 30 Jun 2004, Muhammad R. Sami wrote:

> iptables -A OUTPUT -p icmp -j QUEUE
> 
> Now this should queue all originating ping packets and then depending on
the
> NF mark action will be taken. But it seems that regardless of the NF mark,
> all icmp traffic is blocked. As I remove the above rule from the iptables,
> things work fine.

You don't seem to be using the nfmark in this simple ruleset...

Regards
Henrik
