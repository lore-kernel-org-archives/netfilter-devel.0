From: David Stes <stes@pandora.be>
Subject: Re: Helping helpers help
Date: Sun, 4 Jan 2004 14:27:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040104142730.A5592@D5E02895.kabel.telenet.be>
References: <200401040731.i047VRD32027@singularity.tronunltd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ian Latter <Ian.Latter@mq.edu.au>
Content-Disposition: inline
In-Reply-To: <200401040731.i047VRD32027@singularity.tronunltd.com>; from Ian.Latter@mq.edu.au on Sun, Jan 04, 2004 at 05:31:25PM +1000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


For the specific case of Legato, I don't think there is a problem really,
as the nsrexec port assignment is semi-fixed.

It's true that theoretically it *could* perhaps be dynamically assigned a
different port number than the one it always has.

So I guess the problem is (let's say as an intellectual challenge):

should the connection tracking tuple provide a provision for a helper tha=
t
helps for a dynamically tracked connection.

Or: is it possible to write a helper for a helper.

But on the other hand: somebody who has the skills to run the Legato soft=
ware
on a different port, can probably make the change on all machines, and ju=
st
reconfigure the firewall.

So this is in my opinion an academic problem.

Hey, at least my backups work now over the firewall :-)
Thanks for the RSH and RPC modules!

David.

On Sun, Jan 04, 2004 at 05:31:25PM +1000, Ian Latter wrote:
> Hello,
>=20
>   I am working to help resolve (and make code changes where
> necessary) some sort of conflict that appears to occur between
> the RSH and RPC connection tracking modules, when loaded to
> assist Legato traverse a Linux netfilter firewall.
>=20
>   Any help would be greatly appreciated.
>=20
>=20
>=20
> General;
>=20
>   David has used the RPC conntrack helper module to carry the
> Legato backup software over a netfilter firewall.  He has reported
> that this is working well for client -> server traffic.
>=20
>   However, the Legato server can be used to schedule backups.
> These are then triggered by effectively issuing an "rexec" style
> command, from the server to the client, to initiate the above
> mentioned client -> server backup.  Slightly modifying the RSH
> conntrack helper module (for the high ports involved), David has
> reported success in carrying the rexec traffic over the netfilter
> firewall; ie. server -> client RSH traffic.
>=20
>   On their own, each works fine.  However, putting both of these
> together results in the RSH connection failing.  I think I know why,
> now, but would like some advice.
>=20
>=20
> Specifics;
>=20
>   David has done all of the leg work in identifying the required
> Legato services.
>=20
>   The Legato software has an RPC portmapper operating on
> 7938 (TCP and UDP).  So, the RPC conntracking helper modules
> need to be loaded with "ports=3D7938".
>=20
>   The RPC procedures required by Legato are as follows;
>=20
>       iptables -A INPUT -m rpc --rpcs nsrd,nsrmmd,nsrindexd,nsrmmdbd,
>                                    nsrstat,nsrexec,nsrjb,rap,rapserv -j=
 ACCEPT
>=20
>=20
>   Note that "nsrexec" is really an rexec service that has been written
> by Legato to operate as an RPC module.  The Legato rexec service=20
> is typically found at 7937/TCP, so, the RSH conntracking helper module
> needs to be loaded with "ports=3D7937".  (This is an issue in its own r=
ight,
> but not one in the critical path of the fault).
>=20
>=20
>   Big picture; if all were to work well, then the following communicati=
ons
> would take place during a server scheduled backup;
>=20
>       - rsh 1
>       1. server -> client:7938/[TCP|UDP];  ask for 'nsrexec' service
>       2. portmapper responds; nsrexec =3D> 7937/TCP
>       3. server -> client:7937/TCP  (server designates a high return po=
rt; 9875)
>       4. client -> server:9875/TCP
>       - rsh 2
>       5. server -> client:7938/[TCP|UDP];  ask for 'nsrexec' service
>       6. portmapper responds; nsrexec =3D> 7937/TCP
>       7. server -> client:7937/TCP  (server designates a high return po=
rt; 9893)
>       8. client -> server:9893/TCP
>       - rpc mass activity [client backs up to server]
>=20
>=20
>   Unfortunately, what appears to be happening is a failure at
> step 3.  This is because between 2 and 3, the firewall (due to
> the RPC conntrack helper) adds an expectation for the actual
> RPC procedure call;  server -> client:7937/TCP.  This network
> connection does not appear to be available to the RSH=20
> connection tracker/helper through the conntrack framework.
>=20
>   Therefore, is it true that expected children connections are
> not subjected to the conntrack framework as potential masters,
> for other modules?
>=20
>   Once this "child" connection misses the RSH conntrack helper
> the new expected port is not made available and the process
> fails.  David has confirmed that by explicitly excluding the
> establishment of an expectation for the port 7937/TCP in the
> rpc_tcp conntrack helper code, and adding a static rule for
> 7937/TCP into the filter table, he is able to get the connection
> through to the waiting RSH conntrack helper and the whole=20
> process succeeds.
>=20
>=20
>   Is there a nice way that I can see expectant children=20
> connections from one module, in another?  (without explicitly
> coding for it? -- ie; if Legato code up FTP as an RPC service,
> where would we go from there?).
>=20
>=20
>=20
>=20
> References;
>=20
>   There are two docs that contain a good deal of technical
> information on the Legato networking;
>=20
>     LEGATO TECHNICAL BULLETIN 354:
>     Use of Firewalls with NetWorker=AE Server Release 5.5 and Later
>     http://portal1.legato.com/resources/bulletins/354.html
>=20
>     David Stes'
>     Connection Tracking for Legato NetWorker on Linux
>     http://users.pandora.be/stes/nsrfw04.html
>=20
>=20
>=20
>=20
> Thanks for any assitance rendered,
>=20
>=20
>=20
> --
> Ian Latter
> Internet and Networking Security Officer
> Macquarie University
>=20
>=20
