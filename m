From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: cttest-0.3
Date: 07 Jul 2002 17:10:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1026054628.1283.170.camel@tux>
References: <20020707151703.M13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020707151703.M13116@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2002-07-07 at 15:17, Patrick Schaaf wrote:
> There is now a "cttest-0.3" at http://bei.bof.de/cttest-0.3.tar.gz.
> 
> Also see
> 	http://bei.bof.de/ex2
> 	http://bei.bof.de/ex2rt
> 	http://bei.bof.de/ex2abcd
> 	http://bei.bof.de/ex2crc
> for four example runs contrasting different hash function approaches
> on my transproxy dataset.
> 
> I incorporated hash functions from recent mails of Don and Joakim. Thanks!

The rt hash doesn't do well at all on your data. The winner on your data
is crc32 which is very robust in all tests on all data it seems. It's
just a shame that it's so cpu-consuming compared to the other hashes.

No real diffrence between crc32 and crc32_bof, crc32_bof is slightly
more cpu-consuming but that's it.

Have you tested crc32 with initial seed as well?
crc32 + seed that's randomly generated at conntrack init would probably
work well.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
