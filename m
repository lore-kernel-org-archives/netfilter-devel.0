From: James Morris <jmorris@intercode.com.au>
Subject: Re: IP Queue Conntrack info patch
Date: Mon, 28 Apr 2003 00:39:58 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0304280035260.1422-100000@excalibur.intercode.com.au>
References: <20030427124257.GY990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Evrim ULU <evrim@core.gen.tr>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030427124257.GY990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 27 Apr 2003, Harald Welte wrote:

> On Fri, Apr 18, 2003 at 06:19:49PM +0300, Evrim ULU wrote:
> > Hi,
> > 
> > First post so, flames>>/dev/null ehe:-)
> 
> please talk to james morris about ip_queue changes, he is the original
> author.

My feeling is that any further changes to ip_queue of this nature need to
be done as part of a general redesign and integrated with the nfnetlink
work, as a 2.7 thing.  e.g. it really needs to be a generalized interface
where you can arbitrarily select what information is sent to userspace.


- James
-- 
James Morris
<jmorris@intercode.com.au>
