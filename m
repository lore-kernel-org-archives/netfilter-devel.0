From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: RE: Interfacing custom application with iptables
Date: Wed, 23 Jun 2004 13:48:23 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406231049.i5NAn1MX012895@madinah.ccse.kfupm.edu.sa>
References: <Pine.LNX.4.44.0406211057370.23953-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Henrik Nordstrom'" <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0406211057370.23953-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Can I issue ioctl system calls from within my libipq application program to
configure routing from my application, if yes, can anyone please provide me
with some example code on how to perform this task.
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
Sent: Monday, June 21, 2004 12:00 PM
To: Muhammad R. Sami
Cc: Netfilter List
Subject: Re: Interfacing custom application with iptables

On Mon, 21 Jun 2004, Muhammad R. Sami wrote:

> I would like to assign priority and routing policies on the basis of
> application payload. For this purpose how can your implementation of
> iptables help me? I would like to ask whether I can integrate an
application
> with Iptables such that on entering the interface, every packet goes to my
> application instead of the forwarding module of the iptables where
> application payload is processed and priorities are assigned to each
packet
> and then sent to the forwarding module. For this could you please provide
me
> with information on how to interface my application with iptables? Your
> quick response will be highly appreciated as I am running out of time.
> Thanks in advance.


The easiest approach for this would be to use a slightly extended version
of the QUEUE target / libipq library (library part of iptables package).  
You only need to extend QUEUE with additional return values to set the
nfmark and priority. This has been discussed several times on the 
mailinglist and I thing you can even find patches doing this.

Regards
Henrik
