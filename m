From: James Morris <jmorris@redhat.com>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 00:44:58 -0400 (EDT)
Message-ID: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>
References: <20050426212227.3db90eb2.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050426212227.3db90eb2.davem@davemloft.net>
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

On Tue, 26 Apr 2005, David S. Miller wrote:

> On Wed, 27 Apr 2005 00:22:16 -0400 (EDT)
> James Morris <jmorris@redhat.com> wrote:
> 
> > What's the status of this patch, are there any plans to submit it 
> > upstream?
> 
> If this is the patch I think it is, I believe I told Patrick
> it was too ugly to live :)

It probably is.  I'd like to find a clean way to get at the destination
sock via iptables for locally arriving packets, for SELinux.  i.e. match
incoming packets against a destination security context.

There's already an LSM hook via sk_filter(), but I also need the iptables
framework to make use of matches, targets, chains etc.

I've had one idea for this but it's too ugly to even describe :-)


- James
-- 
James Morris
<jmorris@redhat.com>
