From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Interfacing custom application with iptables
Date: Mon, 21 Jun 2004 10:59:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406211057370.23953-100000@filer.marasystems.com>
References: <200406210648.i5L6m5MX003056@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406210648.i5L6m5MX003056@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 21 Jun 2004, Muhammad R. Sami wrote:

> I would like to assign priority and routing policies on the basis of
> application payload. For this purpose how can your implementation of
> iptables help me? I would like to ask whether I can integrate an application
> with Iptables such that on entering the interface, every packet goes to my
> application instead of the forwarding module of the iptables where
> application payload is processed and priorities are assigned to each packet
> and then sent to the forwarding module. For this could you please provide me
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
