From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: [PATCH] Polish FAQ update.
Date: Sat, 28 Jun 2003 07:25:43 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306280725.43347.fabrice@netfilter.org>
References: <Pine.LNX.4.51.0306261600070.6403@dns.toxicfilms.tv>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.51.0306261600070.6403@dns.toxicfilms.tv>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,

On Thursday 26 June 2003 22:02, Maciej Soltysiak wrote:
> Hello,
> this patch:
> - adds a missing section 3.17
> - adds the translated section 3.18 about REJECT
> - corrects typos
> - introduces smoother and less crappy jargon-like vocabulary.
> Please apply.

Your patch yields rejects for me here.. :
[root@localhost pl]# patch -p0 < /home/fabrice/patch2.diff=20
patching file netfilter-faq.sgml
Hunk #9 FAILED at 127.
Hunk #10 succeeded at 153 with fuzz 2.
Hunk #13 succeeded at 272 with fuzz 2.
Hunk #20 succeeded at 426 with fuzz 1.
1 out of 23 hunks FAILED -- saving rejects to file netfilter-faq.sgml.rej

Could you send the patch again, this time mime encoded ?

Dzi=EAkuj=EA.

Have a nice day,

Fabrice,
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
