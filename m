From: Francesco Sportolari <francesco@unipg.it>
Subject: Re: change timeout values for connection tracking
Date: Tue, 15 Apr 2003 09:44:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304150944.48883.francesco@unipg.it>
References: <Pine.LNX.4.44.0304140825320.15359-100000@ski.isi.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Xuan Chen <xuanc@isi.edu>
In-Reply-To: <Pine.LNX.4.44.0304140825320.15359-100000@ski.isi.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 14 April 2003 17:29, Xuan Chen wrote:
> hi,
>
> could somebody give me some hints on how to change the timeout values i=
n
> connection tracking functions? Say if I want to timeout a connection st=
ate
> (ESTABLISHED) after 2 mins, what should I do?

There is a patch in p-o-m that allows you to change te timeouts of all th=
e=20
states of a tcp or udp connection.

Here's the URL:

http://www.netfilter.org/documentation/pomlist/pom-combined.html#ip_connt=
rack-timeouts

-- Francesco
