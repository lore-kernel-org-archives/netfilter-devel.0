From: James Morris <jmorris@intercode.com.au>
Subject: Re: [libipq] Shutdown problem
Date: Thu, 4 Jul 2002 11:47:54 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0207041144230.13350-100000@blackbird.intercode.com.au>
References: <1257.131.227.137.112.1025733240.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Wei Koong CHAI <eem1wc@eim.surrey.ac.uk>
In-Reply-To: <1257.131.227.137.112.1025733240.squirrel@ike.ee.surrey.ac.uk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 3 Jul 2002, Wei Koong CHAI wrote:

> that it's not the bridge problem. Most probably, it is with my userspace 
> program. 

It shouldn't be possible for the userspace program to cause this.  To 
look into this further, I need to know the details of your system 
topology, iptables & briding configuration, and all startup and shutdown 
messages relating to networking.


- James
-- 
James Morris
<jmorris@intercode.com.au>
