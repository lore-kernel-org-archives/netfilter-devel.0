From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: Userspace queuing
Date: Sat, 26 Jun 2004 11:17:40 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406260818.i5Q8ILMX023595@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0406260128520.8200-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Netfilter List'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0406260128520.8200-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

But as far as I have worked on it, I an only accept or drop packets using
libipq and Queue. What if I want to set priority to accepted packets, like
high priority and low priority, can this be also done using the same or
there is some other mechanism in iptables. 
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
Sent: Saturday, June 26, 2004 2:30 AM
To: Muhammad R. Sami
Cc: Netfilter List
Subject: Re: Userspace queuing 

On Fri, 25 Jun 2004, Muhammad R. Sami wrote:

> Is there a way to perform userspace queuing in iptables? If yes can I have
> some example codes.

Yes, via QUEUE and libipq.

examples on how to use libipq is included in the libipq documentation.

libipq is shipped together with iptables.

Regards
Henrik
