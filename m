From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] addrtype match
Date: Wed, 9 Apr 2003 13:29:04 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304091326110.17281-100000@el-zoido.localnet>
References: <1049887278.3282.138.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1049887278.3282.138.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On 9 Apr 2003, Martin Josefsson wrote:

> There actually isn't any real need to duplicate and renumber.. just use
> (1 << RTN_UNSPEC) .... I think enum starts at 1 but that will only mean
> you loose one bit, you don't need 32 bits anyway :)

...

> Sorry about all the extra comments now after you've already made a new
> patch... the only thing I really want to see is the removal of the code
> duplication in the kernel. The table in userspace would just be a lot
> nicer than all the if-statements, and to me almost more readable.

No harm done, i was just starting to make some of the changes you 
suggested when your mail arrived, i too don't like big switch statements ;)

Thanks again,
Patrick
