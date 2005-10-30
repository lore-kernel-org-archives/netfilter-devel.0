From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] make ipv6_find_hdr() find transport protocol header
Date: Sun, 30 Oct 2005 15:58:45 +0100
Message-ID: <4364DFA5.7060405@trash.net>
References: <200509240857.j8O8vaQ2006429@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200509240857.j8O8vaQ2006429@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sat, 17 Sep 2005 21:25:02 +0200
> 
>>This patch looks great, applied. It looks like we could also replace
>>the code in ip6_packet_match, the special treatment of IPPROTO_ESP
>>doesn't look right anyway.
> 
> Sounds good. ESP handling isn't difficult because ipv6_ext_hdr() doesn't
> check ESP. But special handling of Fragment header is necessary, to get
> "next header" field and fragment offset in it if packet isn't 1st fragment.
> 
> Note that I didn't unify ipv6_skip_hder() because I plans a optimization around
> this.
> 
> I've tested this patch with AH, ESP, Fragment header combinations, but
> have not tested with other extension headers because now I'm on trip and
> have only a laptop, sorry.

Finally applied, sorry for the delay.
