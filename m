From: Patrick McHardy <kaber@trash.net>
Subject: Update: Patch-o-matic cleanup
Date: Wed, 05 Apr 2006 15:47:33 +0200
Message-ID: <4433CA75.9040607@trash.net>
References: <443165AA.4030509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <443165AA.4030509@trash.net>
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

Patrick McHardy wrote:
> Following (quite late) the decision taken at the netfilter workshop to
> clean up the pomng repository by removing old patches and moving some
> patches out of the netfilter repository, I've started by removing the
> obsolete ipsec* patches and the policy match. Both have been merged
> and were pretty outdated.
> 
> If noone can name good reasons against it, I will also remove the
> following patches in a few days:
> [...]

After receiving multiple "please keep this patch" mails, it seems I
started the wrong way.

Removing old patches is part of a greater plan to reduce the content of
pom to only those things the netfilter team has an interest in
maintaining, and most of these things will be merged in not too long
time. _All_ other patches will be removed and the "runme" tool will
be enhanced by an apt-get like mechanism to download patches from
external sources, so people interested in keeping patches around can
maintain them themselves and publish them somewhere for others to use.
This should benefit both us and the authors since they usually maintain
their own versions of the patches anyway and periodically send us
updates to include in pom, which unnecessarily cost time for everyone
involved.

This is the full list of patches to be removed. Instructions how to set
up a pomng repository are at the end of this mail, I'll commit the code
soon.

- ACCOUNT
- IPMARK
- NETLINK
- NETMAP
- TARPIT
- TCPLAG
- TRACE
- XOR
- account
- comment
- connlimit
- connrate
- conntrack_locking
- cuseeme-nat
- dropped-table
- expire
- fuzzy
- geoip
- goto
- ip_queue_vwmark
- ipp2p
- mport
- nat-reservations
- netfilter-docbook
- osf
- owner-socketlookup
- pool
- pptp-conntrack-nat
- psd
- time
- tproxy

The patches will be removed in 30 days, authors or other people that
want to maintain them in an external repository are welcome to send
the URL to be included in the distrubuted sources.list.

How to set up a repository:

The repository must be accessible in a way supported by curl (HTTP or
FTP for example). The name of each patchlet is listed in a file named
"index". Each patchlet must be contained in a .tar.gz file, which
contains a directory named like the patchlet itself. The directories
contents are similar to those in patchlets/ today, but the Repository
specified in the info file must be "external".

So to create a repository from one of the patches currently in pom:

- cd patchlets
- edit $patch/info, change repository to "external"
- tar cz $patch > /wwwroot/pom-repo/$patch.tar.gz
- echo $patch >> /wwwroot/pom-repo/index

As I said above, I'll commit the code for this soon.
