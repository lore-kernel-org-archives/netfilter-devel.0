From: James Morris <jmorris@intercode.com.au>
Subject: Re: [PATCH] Iptables multiport match fix
Date: Wed, 10 Jul 2002 19:23:51 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0207101922001.1563-100000@blackbird.intercode.com.au>
References: <veznx0ejov.fsf@inigo.ingate.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <veznx0ejov.fsf@inigo.ingate.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 9 Jul 2002, Marcus Sundberg wrote:

> Hi,
> 
> The multiport match checks for the IPT_INV_PROTO flag in the 'flags'
> member of struct ipt_ip instead of in the 'invflags' member.
> 

Thanks, the patch looks good, even though inverted multiport isn't 
functional.

> (Where should I send this btw? The kernel part of iptables doesn't
> seem to be in the netfilter CVS. Was I supposed to create a p-o-m
> patch? Or send it directly to Marcelo?)
> 

netfilter-devel is the best bet.


- James
-- 
James Morris
<jmorris@intercode.com.au>
