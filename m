From: Patrick McHardy <kaber@trash.net>
Subject: Netfilter+IPsec patches in pom-ng now
Date: Wed, 14 Apr 2004 04:30:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <407CA248.3000302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mludvig@suse.cz,  guillaume@morinfr.org,  alex@samad.com.au,
 herbert@gondor.apana.org.au,  JMChandonia@lbl.gov
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've just commited the netfilter+ipsec patches to pom-ng.

The input patch is replaced with a new version which just
posts packets which are done with ipsec into the stack again
and lets them traverse the hooks at the usual places. The
advantage is the simplicity and transparency for netfilter,
the disadvantage is an extra pass through the stack.

Some bugs have been fixed since the last set of patches:

- IPIP packets decapsulated from IPsec missed the input hooks
- multiple other problems related to the old input patch
- compiles without CONFIG_NETFILTER
- icmp/igmp didn't traverse POST_ROUTING before encapsulation
- possible NULL-ptr dereference fixed

They still need some work but mostly cleanup, nothing critical.

The patches are split into four parts, but pom-ng does not handle
recursive dependencies when dependant patches change the same
piece of code and --dry-run fails, so the patches need to be
applied manually in the right order. The patches are named in
a way that they will appear in the correct order during "runme".

Regards
Patrick

PS: I've CCed some people who showed interest, but who I think
are not subscribed to the list. Please tell me in private if
you want don't want these mails.
