From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Is libiptc responsible for any memory leak?
Date: 07 Jan 2003 14:13:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1041945228.30004.8.camel@tux>
References: <Pine.LNX.4.43.0301071139010.282-100000@abodh.pesit.deeproot.co.in>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	leonardo@opalsoft.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Narendra Prabhu. B" <naren@deeproot.co.in>
In-Reply-To: <Pine.LNX.4.43.0301071139010.282-100000@abodh.pesit.deeproot.co.in>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-01-07 at 07:40, Narendra Prabhu. B wrote:
> 
> Hi,
> 
> Few days back I had posted, regarding memory leakage in the libiptc
> APIs.
> 
> I worked more closely with libiptc and some debuggers(ccmalloc ,valgrind).
> Now I able able to, precisly point out functions(APIs) were responsible
> for memory leakage:-
> 
> 1> iptc_init(..)
> 	there is some memory leakage here... but if we mention that
> free(the_handle), there is no memory leakage from here.. This is not done
> in iptables-save.c function "static int do_output(const char *tablename);
> " seems like the free(h) was commented out. ref: iptables-1.2.7a
> 
> 2> iptc_first_chain(..)
> 	here to there is some memory leakage.
> 
> 
> Are the developers aware of this?
> Hope we get some response.

If you search the archives you'll see that we are aware of this. But
since libiptc isn't intented to be used outside of iptables noone has
bothered to spend any time to find out where it leaks memory.

So don't expect anyone to send you a patch any time soon. But we do
accept patches :)

So please continue your investigation and send a patch, it will probably
be happily accepted if it's correct.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
