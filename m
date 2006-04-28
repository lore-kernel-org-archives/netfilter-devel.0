From: David Coulson <david@davidcoulson.net>
Subject: Re: Support for longest prefix IP address match in iptables?
Date: Fri, 28 Apr 2006 17:08:20 -0400
Message-ID: <44528444.8080504@davidcoulson.net>
References: <38539.192.168.20.50.1146211317.squirrel@pop-mail>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, nbasker@india.tejasnetworks.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: shyam@india.tejasnetworks.com
In-Reply-To: <38539.192.168.20.50.1146211317.squirrel@pop-mail>
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

shyam@india.tejasnetworks.com wrote:
> iptables -t mangle -A POSTROUTING -d 10.12.13.14 -j MARK --set-mark=5
> iptables -t mangle -A POSTROUTING -d 10.12.13.0/24 -j MARK --set-mark=7

Put these rules the other way around. AFAIK, MARK does not exit the
chain after a match.

David
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEUoRETIgPQWnLowkRAp1IAJ41tAgE9Bi5uRuvJU6dpTLzbd1nngCfc0pW
bKj0maY/Im8E8PIEonQrXtk=
=FQvS
-----END PGP SIGNATURE-----
