From: Patrick Schaaf <bof@bof.de>
Subject: Re: string match -> new option
Date: Sat, 1 Mar 2003 07:39:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030301063948.GF24025@oknodo.bof.de>
References: <15760529186.20030301025308@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lista de correo netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: macadanet@yahoo.es
Content-Disposition: inline
In-Reply-To: <15760529186.20030301025308@yahoo.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I modificated ipt_string.c

Sigh. Why is it that people must work on the pieces that others
already abandoned as fundamentally broken? See my point 1), below.

> This patch acepts regular expresions.

It was only a question of time...

> For example:
> 
> iptables -A INPUT -m string --string '"GET"[0-9]"HTTP"' -j LOG

> If some package includes the string: GET ???????8????????? HTTP
> the system will write in log file.

> What do people think? Is a good idea?

1) it is mostly a bad idea to use the string match at all, as it does
   not reassemble a TCP stream, and thus strings that happen to be
   broken up in two TCP segments, are not matchable. This is a
   fundamental limitation, making any security you get out of
   such a rule dubious, best-effort, only-in-good-weather pseudo
   security.
2) The string in your example, above, is not in a common form I would
   recognize as a regular expression - or your example is wrong, and the
   expression won't match that string. I assume that you invented an
   ad-hoc a-bit-similar-to-regexp matching and syntax, right?
   That's a bad idea. Yet another language to learn (or better ignore).
3) It is a bad idea to use the same --string option as before but
   totally change the interpretation of the string. See the other
   string extension proposal discussed right now. Use a new, extra
   option, or better yet, write a totally new match.
4) It is probably a bad idea, once you analyze the runtime overhead
   imposed by full packet regexp matching. But this would have to
   be quantified, it's just a feeling. It will DEFINITELY become
   really interesting to analyze when you solve points 1 (reassembly
   of TCP stream) and 2 (real regexpen), due to all the deep
   backtracking that regexpen could do. Also watch the severely
   limited kernel stack, if your implementation happens to be
   a naive recursive one! You won't want a slightly more complex
   packet to crash the kernel due to stack exhaustion!

best regards
  Patrick
