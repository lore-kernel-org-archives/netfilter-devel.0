From: Patrick Schaaf <bof@bof.de>
Subject: Re: testing checksum in helpers is redundant with tcp_window_tracking
Date: Fri, 28 Feb 2003 10:04:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030228090438.GB24025@oknodo.bof.de>
References: <20030227222154.GA9692@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030227222154.GA9692@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Then helpers could wrap their tcp checksum calls with something like:
> 
> #ifndef TCP_WINDOW_TRACKING
> ...
> #endif

Please don't do it that way. If you have to write the same ifdef several
times in several .c files, you are doing something wrong.

The good way is this:

- make all places call a single "check sum in conntrack helper" function.
- define that function as a 'static inline' in one of the existing .h files,
  where it logically fits. Make that definition dependant on the
  WINDOW_TRACKING define, providing a completely empty 'static inline'
  function when the window tracking compile option is set.

Done this way, the call sites are not uglified by ifdefs, and it's still
a compile-time go-away-code situation. This scheme is used in lots of
places in the kernel.

What happens with incremental modular compiles, and the user
flipping the WINDOW_TRACKING switch? i.e. some modules compiled one
way, and some compiled the other way?

For a possible other approach: isn't there some flag in the skbuff,
normally used by the local TCP stack, which can remember that a checksum
was done, and it was ok? I remember such things being introduced when
they started supporting hardware checksums, but I'm ignorant of any
detail. Could it be that the conntrack/helpers might just also use
that infrastructure?

best regards
  Patrick
