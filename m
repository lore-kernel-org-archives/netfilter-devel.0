From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [PATCH] gcc4 fixes ip_conntrack_core.c/nf_conntrack.h.
Date: Sun, 24 Apr 2005 21:05:44 +0200
Message-ID: <426BEE08.9030300@gmx.net>
References: <200504221657.37760.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@pld-linux.org>
In-Reply-To: <200504221657.37760.pluto@pld-linux.org>
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

Pawel Sikora wrote:
> 
> Attached patches fix build issues exposed by gcc4.
> Please review and apply.
> 
> Regards,
> Pawel.
> 
> -- 
> /* Copyright (C) 2003, SCO, Inc. This is valuable Intellectual Property. */
> #define say(x) lie(x)


Am I the only one getting nervous when somebody sends a patch
which has no Signed-off-by line, but includes a comment saying
that this is "(C) 2003, SCO, Inc."?

Regards,
Carl-Daniel
