From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching
Date: Wed, 06 Apr 2005 21:47:22 +0300
Message-ID: <42542EBA.9050606@outerspace.dyndns.org>
References: <20050407000158.02AA.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050407000158.02AA.LARK@linux.net.cn>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Wang Jian wrote:

| iptables <match rule 1> -j CONNMARK --set-mark value/mask
| iptables <match rule 1> -j RETURN
|
| How many times the match rule 1 is evaluated when matched? If two, then
| the second time is waste of CPU cycle.

It evaluates twice. I have made a "previous" match which I haven't finished
into a patch yet (some cleanup, documentation and iptables-save & -restore
support). It lets you do the above like this:

iptables <match rule 1> -j CONNMARK --set-mark value/mask
iptables --previous -j RETURN

| Then think these three
|
| iptables <match rule 1> -j CONNMARK --set-mark value/mask
| iptables <match rule 1> -j CONNMARK --restore --mask mask
| iptables <match rule 1> -j RETURN
|
| Are there any optimization for such case?

I would guess mask restoring is usually done globally without matching some
specific criteria.. but nevertheless, the --previous could be used here if
wanted, it can be used many times in a row.

I'll try to finish off the patch tomorrow.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCVC64xyF48ZTvn+4RAi8pAJ4sjXT1KZf5Ora6S0Rr5dCXmcGj9gCgzKQi
OUx6jdlw3FvPEtVuWgZ2/j8=
=bp5F
-----END PGP SIGNATURE-----
