From: Andrej Ricnik <andrej@paradise.net.nz>
Subject: How/where does the kernel map packets to an application ...
Date: Thu, 15 Jan 2004 09:10:30 +1300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401150910.32898.andrej@paradise.net.nz>
Reply-To: andrej@paradise.net.nz
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Content-description: clearsigned data
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Guys,

and sorry for asking this here, I'm aware of the fact that
this isn't quite the right list to do so, in fact, I don't even
know how to word my question properly, so please bear
with me.

Since you're pretty close to what I suspect to be the right
layer to be looking at I hope someone might understand
what I'm on about :)

My idea is to write an addition to netfilter that will check=20
the originating application of an IP request against a list
of allowed files, and if I handle that well enough, integrate
a roster of user/application to check whether a request is
legal or not.

My question is:
At which point does the kernel determine which application
a incoming packet is meant for? Imagine one user having
mozilla and opera open, using both for browsing. Another
user having a links session in a console. How does the
kernel determine which application is meant to receive
a incoming packet on port 80? I hope that once I under-
stand how this works I could for instance use lsof or a
tool the like to intercept illegal requests by matching=20
against application name/path ...

If this is a FAQ, or just plain stupid, please throw me a
link to appropriate documentation.

Thanks in advance, and thanks for your patience,
Cheers,
Tink
