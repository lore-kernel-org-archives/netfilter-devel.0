From: Pablo Neira <pablo@eurodev.net>
Subject: Re: NF fields in sk_buff
Date: Wed, 04 Feb 2004 14:50:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4020F891.4040704@eurodev.net>
References: <401A7C04.8060803@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi, netfilter-devel@lists.netfilter.org
In-Reply-To: <401A7C04.8060803@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi emmanuel,

Emmanuel Guiton wrote:

> Hi!
>
> I want to send a "built-by-hand" packet on the local hook. In the 
> sk_buff structure, there is two fields, nfmark and nfcache, which  I 
> don't really understand. Can someone give me a quick briefing on these 
> two fields?
> Quick search with google made me feel that I don't need them anyway 
> and that I can leave them blank. Right?


I know something about nfcache, I think that it's a Rusty's idea to 
improve the performance and avoid that a packet hits all the hooks but 
it wasn't implemented. See netfilter hacking how-to. section 4.5.

I think that you are right, you could leave them blank.

Pablo
