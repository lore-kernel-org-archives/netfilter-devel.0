From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: CONNMARK again..
Date: Tue, 23 Mar 2004 02:13:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403230211590.23238-100000@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF5122F25@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5122F25@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 22 Mar 2004, Daniel Chemko wrote:

> Ok, I wrote a few weeks back about getting policy routing working. I
> did!
> 
> The problem is that I've updated to the latest 2.4 POM and -j CONNMARK
> --save-mark doesn't seemt o be working anymore.

Have you updated your iptables userspace? CONNMARK was cleaned up some 
time ago and new kernels is not compatible with old binaries..

Regards
Henrik
