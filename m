From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Sun, 07 Nov 2004 17:39:43 +0100
Message-ID: <418E4FCF.5090601@trash.net>
References: <20041104121522.GA16547@merlin.emma.line.org>
	<418A7B0B.7040803@trash.net>
	<20041104231734.GA30029@merlin.emma.line.org>
	<418AC0F2.7020508@trash.net> <418BE156.4020400@eurodev.net>
	<418BFC5C.20201@trash.net>
	<20041107121637.GC29510@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
In-Reply-To: <20041107121637.GC29510@merlin.emma.line.org>
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

Matthias Andree wrote:

>IMNSHO, str* functions have no business in arbitrary data. I have a
>simple memstr() function in bogofilter that is GPL'd and can be imported
>into the kernel, I believe:
>
>  
>
It's not only strstr, it also uses simple_strtoul.
If you don't like it, send a patch.
