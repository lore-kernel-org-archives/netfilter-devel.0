From: James Morris <jmorris@intercode.com.au>
Subject: Re: libipq packet id
Date: Fri, 27 Sep 2002 00:37:50 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0209270037340.12159-100000@blackbird.intercode.com.au>
References: <002301c26555$971a8b80$97025a3e@SHAGWELL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Moshe Ashkenazi <moshea@checkpoint.com>
In-Reply-To: <002301c26555$971a8b80$97025a3e@SHAGWELL>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Sep 2002, Moshe Ashkenazi wrote:

> Hi, All -
> 
> I'm using libipq to retrieve packet from netfilter in userspace, and its
> work cool.
> 
> My question is how can I know on userspace mode from which netfilter
> rule the packet arrive?    
> 

This information is not passed to userspace.

-- 
James Morris
<jmorris@intercode.com.au>
