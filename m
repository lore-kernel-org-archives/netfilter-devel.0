From: Herve Eychenne <rv@wallfire.org>
Subject: Re: System with really big statetable crashing while doing "cat /proc/net/ip_conntrack | wc -l"
Date: Fri, 23 Apr 2004 18:31:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040423163130.GA1210@eychenne.org>
References: <40875ECE.1000405@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jens Hektor <hektor@rz.rwth-aachen.de>
Content-Disposition: inline
In-Reply-To: <40875ECE.1000405@rz.rwth-aachen.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Apr 22, 2004 at 07:57:34AM +0200, Jens Hektor wrote:

 Hi,

> we are running a production packetfilter based on Fedora Core-1
> actual vanilla  2.4.22-1.2179.nptl-smp.

> This packetfilter is in front of two class-B's and it has a big
> statetable, really. We guess that it's about 200k entries.

> So we only can guess for if doing
> cat /proc/net/ip_conntrack | wc -l
> the system reproducably crashes.

> We had the same effect on non-smp and 2.6 version of Fedora kernels
> and I guess that the same might happen with the vanilla kernel.

> Is this known, has anyone ever seen this?

Yes, alas! See
http://lists.netfilter.org/pipermail/netfilter-devel/2003-December/013557=
.html

But is wasn't reproduced since then because we didn't dare to touch
/proc/net/ip_conntrack after that ;-/, as it is a production machine...
No oops trace either, as we had to reboot it as soon as possible for
the same reason.

And let me tell you that tftp was absolutely not loaded, so it cannot
be the root of our problem.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
