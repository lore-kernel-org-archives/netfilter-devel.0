From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Userspace queuing
Date: Sat, 26 Jun 2004 01:30:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406260128520.8200-100000@filer.marasystems.com>
References: <200406251811.i5PIBlMX013526@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
In-Reply-To: <200406251811.i5PIBlMX013526@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 25 Jun 2004, Muhammad R. Sami wrote:

> Is there a way to perform userspace queuing in iptables? If yes can I have
> some example codes.

Yes, via QUEUE and libipq.

examples on how to use libipq is included in the libipq documentation.

libipq is shipped together with iptables.

Regards
Henrik
