From: Bernd Petrovitsch <bernd@gams.at>
Subject: Re: question for (existing?) feature
Date: Mon, 17 Mar 2003 13:39:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <2405.1047904769@frodo.gams.co.at>
References: <20030316111759.GA20717@posern.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "K. Posern" <k@posern.org>
In-reply-to: Your message of "Sun, 16 Mar 2003 12:17:59 +0100."
             <20030316111759.GA20717@posern.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

"K. Posern" <k@posern.org> wrote:
>Is there a possibility to provice a description to rule - which will be =
printe
>d out with "iptables -L" or "iptables -L -v"???

Yes, just implement a comment field.

>The idea of such a (self-choosen) description would be that you have spe=
aking =

>explanations for the several rules - so that it is MUCH easier to keep i=
n mind
> the purpose of each line which is printed with the -L flag.
>
>Cause me for myself builds up a firewall rule by rule (understanding the=
m and =

>what I am doing (hopefully) too). And I have lots of comments in the fil=
e buil
>ding the firewall. But nevertheless I would like to recheck everything w=
ith th
>e -L flag and at this point (short) names for rules would be very nice t=
o have
>.

Same for me. The firewall-rule structure is pretty simple - fluash =

everything at the start, no user chains, just append the next rule - so
it is pretty easy to check the rules.
The comments are in the script and I only edit there and simply =

start the script - voila, now config is applied.

>So my questions all together:
>
>    Is there a possibility like this already?

No.

>    What are you thinking about it?

It is more than superflous (read: No, do not do it.). Reason: see =

above.


	Bernd
-- =

Bernd Petrovitsch                              Email : bernd@gams.at
g.a.m.s gmbh                                  Fax : +43 1 205255-900
Prinz-Eugen-Stra=DFe 8                    A-1040 Vienna/Austria/Europe
                     LUGA : http://www.luga.at
