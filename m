From: Giacomo <delleceste@gmail.com>
Subject: Knowing command path
Date: Fri, 13 Jan 2006 17:10:35 +0100
Message-ID: <885896af0601130810x1cd6d8d4n@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter devel <netfilter-devel@lists.netfilter.org>
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

Good morning, is there a way to get the command name of a process
together with its full execution path.

That is, if i read the field 'comm' of a task struct associated with pid X,
i get the process name, i.e. "firefox"
But i would like to read "/usr/local/bin/firefox" instead.

Thanks a lot!


--

Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Running `IPFIRE-wall` on debian GNU/Linux
http://www.giacomos.it/ipfire
http://www.debian.org

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -
