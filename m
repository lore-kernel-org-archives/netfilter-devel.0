From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: port parameter of ftp conntrack module
Date: Tue, 14 Oct 2003 20:13:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310142012170.19333-100000@filer.marasystems.com>
References: <001a01c3915f$6be869a0$fe0210ac@phuongnb>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nguyen Binh Phuong <phuongnb@sunyard.net.tw>
In-Reply-To: <001a01c3915f$6be869a0$fe0210ac@phuongnb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 13 Oct 2003, Nguyen Binh Phuong wrote:

> 1/ How can ftp conntrack module is called inside kernel?

By the definition of the ftp helper in the ftp helper module conntrack 
knows that for ftp traffic it needs to call the ftp helper.

> 2/ How can ftp conntrack module get ports parameter inside kernel? Who does transmit value of port parameter to init() function of ip_conntrack_ftp.c?

Either compiler info ip_conntrack_ftp, or as module arguments when you 
instert the module into the kernel.

Regards
Henrik
