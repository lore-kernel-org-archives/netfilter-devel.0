From: Frank 'xraz' Fricke <xraz@rwxr-xr-x.de>
Subject: Re: ip6t_ROUTE target
Date: Sat, 14 Jun 2003 12:10:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030614121005.587bd014.xraz@rwxr-xr-x.de>
References: <20030516221652.3d86c00a.xraz@rwxr-xr-x.de>
	<20030519124603.GA27460@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andras Kis-Szabo <kisza@securityaudit.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030519124603.GA27460@sch.bme.hu>
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

sorry for the late reactionb. i was very busy last weeks.

On Mon, 19 May 2003 14:46:03 +0200
Andras Kis-Szabo <kisza@securityaudit.hu> wrote:

|As I know - the new modules should be added to 2.5.x. You have the old
|Configure.help format instead of Kconfig.

it was just planned as a hot fix as long as ip6-policy-routing does not
work. so i did it for 2.4. i'll check out how things work in 2.5 if this
target should go into.

|You do not use the C99 initializers in the structures.

i can not see where i should use them - can you give an example? kernel
hackers guid does not help me.

|Could you update your patches?

i'll make one for 2.4.21 soon because i need it and i'll also try to
produce one for 2.5.latest. unfortunately i have no seperate testing
system for unstable kernels so this could take a while.

|Thank you in advance,

thank YOU for all the good and free software :)

     ...Frank

- -- 
http://www.gnupg.org         |         http://xraz.de/gpg.key
Fingerpint: C1E1 0A5C 3733 F4F1 D59B 14F7 57C6 1784 8F78 8A2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+6vR9V8YXhI94iisRAsH9AJ9Sg1KyEBxU3NDX6TravwUkHRitAgCbB7tc
bfce/xY9PKCY6WNnDP5wP1w=
=tQOJ
-----END PGP SIGNATURE-----
