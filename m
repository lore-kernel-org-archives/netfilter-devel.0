From: P@draigBrady.com
Subject: Re: performance
Date: Tue, 10 Jun 2003 09:49:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EE59BB2.1070009@draigBrady.com>
References: <3EE4B1EB.9090305@draigBrady.com> <3EE4B2E3.2070700@draigBrady.com> <723210746.20030609212730@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peteris Krumins <newsgroups@lf.lv>, netfilter-devel@lists.netfilter.org
In-Reply-To: <723210746.20030609212730@lf.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Peteris Krumins wrote:
> Monday, June 9, 2003, 7:16:35 PM, you wrote:
>=20
> Pdc> P@draigBrady.com wrote:
>=20
>>>Hi,
>>>
>>>I'm testing netfilter performance here on
>>>PIII 1.2GHz based systems. With default
>>>kernel configuration, netfilter is able
>>>to process 85,000 pps with 125 rules (all
>>>rules matching).
>>>
>>>Note the application is just counting.
>>>There is no transmitting/forwarding.
>>>
>>>Also note the nics are e100.
>>>
>>>So my simple question are there any
>>>tips in increasing the performance?
>>>Hmm actually the performance seems
>>>optimal? is it only taking 9 instructions
>>>per match? 1.2*10^9/(85000*1500) =3D 9
>=20
>=20
> Pdc> I knew that couldn't be right.
> Pdc> That was tested on a dual 1.2GHz,
> Pdc> so that should be approx:
> Pdc> 2*10^9/(85000*125) =3D 188 instructions per match.
>=20
> I am afraid that is not instructions per match
> but ticks per match? An instruction can take more than
> one tick (clock cycle).

yes true. I was making assumptions.
The following suggests the average cycles:instruction
ratio is 1.68 I think:
http://www.cs.berkeley.edu/~pattrsn/252S01/Lec18-dynamic3.pdf

Looking again at the system it's actually 2 x 1.4GHz
So the instructions per match are about:
((2.8*10^9)/1.68)/(85000*125) =3D 156

With the overhead associated with SMP/kernel/...
this suggests a figure closer to 120?
I'm very impressed.

So to scale I would have to organise the rules
into chains that could be bypassed. I wonder is
there any projects to do this automatically? hmm..

P=E1draig.
