From: "Daniel De Graaf" <danieldegraaf@gmail.com>
Subject: Re: downloads site
Date: Mon, 12 Jun 2006 20:51:11 -0500
Message-ID: <427c54c0606121851x4e8cddecvb9dc93784056c53b@mail.gmail.com>
References: <BAY117-F18CE8E74456214B0AE70F3AD8F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <BAY117-F18CE8E74456214B0AE70F3AD8F0@phx.gbl>
Content-Disposition: inline
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

On 6/12/06, Jethro Tull <heavytull@hotmail.com> wrote:
> on the ftp place to download iptables source codes there are tar balls
> in the iptables/ directory and I can see the latest verion (1.3.5) but
> the another directry in it called snapshot/ In which there are some
> even newer versions, I would like to know what means that directry
> called snapshot/ is it the location of some special unstable version??
> why do they not put those tar balls in the main dir iptables/ ???
>
> also, I read in the INSTALL file in the tar ball that to get latest
> bugs solved one should apply the patch'o'matic files, but on the ftp
> site I find files called 'patch 1.y.x to 1.y.x+1' and older than the
> newest tarballs in the snapshot/ dir.
> usually on any project they suggest the main release and suggest a new
> patch very frequently. but here it is the contrary.
>
> also i can find patch'o'matic files but are older than newest 'patch
> 1.y.x to 1.y.x+1'  files, does that mean patch'o'matic files are no
> more in use?
>

The snapshots are from subversion, which you can view at
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/. This is the
development code, which may have bugfixes and/or new bugs; you can
view the changes at that URL.

Patch-o-matic is obsolete; it has been replaced by patch-o-matic-ng,
which is just a collection of targets/matches. It should be retrieved
from a snapshot or directly from svn. The bugfixes have all been added
to the mainline kernel.
