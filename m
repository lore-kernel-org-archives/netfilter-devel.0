From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [PATCH] Some parameter fixes for ip(6)tables.c
Date: Sat, 09 Apr 2005 23:35:40 +0000
Message-ID: <425866CC.3020809@outerspace.dyndns.org>
References: <424144D6.2090107@outerspace.dyndns.org>
	<20050401063500.GM19835@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050401063500.GM19835@sunbeam.de.gnumonks.org>
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

Hello, sorry for my late reply..

Quoting Harald Welte on 2005-04-01 06:35 UTC:

|> 2. the commands_v_options two-dimensional array lacks a column for the
|> -c flag. I tried to deduce feasible values, please look at them before
|> accepting :)
|>
|> 3. the inverse_for_options array lacks a row for the -c flag. By
|> looking at the code I figured it does not allow the "!" inversion
|> option, so I constructed the line accordingly.
|
|
| erm, do you find something that actually implements CMD_CHECK?

No I didn't..

What would you like me to do? Should I improve my patch to take out
CMD_CHECK and adjust the bit masks accordingly? Unless I got something
wrong, my fix 3 above wasn't related to CMD_CHECK in any way..?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCWGbKxyF48ZTvn+4RAhlOAJ4mSLXoXP7EGUhgi12YgSYPxgrPjgCcCTiC
c22FIgr6OvJYk2Jb4XpyNgo=
=XTlA
-----END PGP SIGNATURE-----
