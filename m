From: Sam Johnston <samj@aos.net.au>
Subject: Re: Patch with additional options for quota match
Date: Tue, 29 Apr 2003 07:09:41 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EAD9895.6020408@aos.net.au>
References: <3E9DCA15.40C99A6C@info-link.net> <20030427124055.GX990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Brad Fisher <brad@info-link.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030427124055.GX990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Harald Welte wrote:

| On Wed, Apr 16, 2003 at 04:24:37PM -0500, Brad Fisher wrote:
|
|>I have made up a small patch for the quota match by Sam Johnston to add
|>a couple of options I find useful - negated matching and the option to
|>count total packet size (data + headers) instead of just data size.
|
|
| I don't want to include this without the orignal author's permission.
| Please contact Sam Johnston about your changes and ask him if he agrees
| with those changes.

Harald,

Thankyou for confirming changes with me. I haven't seen this patch, so
can someone please forward it on. The changes requested sound reasonable
in principal - for most applications counting the headers is probably
what is intended although this is a change in functionality. I'm not
sure about the applications for negated matching but no doubt someone
somewhere will find it useful.

Sam

- --
Sam Johnston, Director
Australian Online Solutions
1300 132 809

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE+rZiVj4XJViLpTR0RAmW3AJ48YYYbgoNHI0bc18nRd4rszsmtTQCfcoeN
4mg8d/NVh50OSF9A2fMPTHY=
=obWm
-----END PGP SIGNATURE-----
