From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Helping helpers help
Date: Sun, 04 Jan 2004 17:31:25 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401040731.i047VRD32027@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: "David Stes" <stes@pandora.be>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  I am working to help resolve (and make code changes where
necessary) some sort of conflict that appears to occur between
the RSH and RPC connection tracking modules, when loaded to
assist Legato traverse a Linux netfilter firewall.

  Any help would be greatly appreciated.



General;

  David has used the RPC conntrack helper module to carry the
Legato backup software over a netfilter firewall.  He has reported
that this is working well for client -> server traffic.

  However, the Legato server can be used to schedule backups.
These are then triggered by effectively issuing an "rexec" style
command, from the server to the client, to initiate the above
mentioned client -> server backup.  Slightly modifying the RSH
conntrack helper module (for the high ports involved), David has
reported success in carrying the rexec traffic over the netfilter
firewall; ie. server -> client RSH traffic.

  On their own, each works fine.  However, putting both of these
together results in the RSH connection failing.  I think I know why,
now, but would like some advice.


Specifics;

  David has done all of the leg work in identifying the required
Legato services.

  The Legato software has an RPC portmapper operating on
7938 (TCP and UDP).  So, the RPC conntracking helper modules
need to be loaded with "ports=7938".

  The RPC procedures required by Legato are as follows;

      iptables -A INPUT -m rpc --rpcs nsrd,nsrmmd,nsrindexd,nsrmmdbd,
                                   nsrstat,nsrexec,nsrjb,rap,rapserv -j ACCEPT


  Note that "nsrexec" is really an rexec service that has been written
by Legato to operate as an RPC module.  The Legato rexec service 
is typically found at 7937/TCP, so, the RSH conntracking helper module
needs to be loaded with "ports=7937".  (This is an issue in its own right,
but not one in the critical path of the fault).


  Big picture; if all were to work well, then the following communications
would take place during a server scheduled backup;

      - rsh 1
      1. server -> client:7938/[TCP|UDP];  ask for 'nsrexec' service
      2. portmapper responds; nsrexec => 7937/TCP
      3. server -> client:7937/TCP  (server designates a high return port; 9875)
      4. client -> server:9875/TCP
      - rsh 2
      5. server -> client:7938/[TCP|UDP];  ask for 'nsrexec' service
      6. portmapper responds; nsrexec => 7937/TCP
      7. server -> client:7937/TCP  (server designates a high return port; 9893)
      8. client -> server:9893/TCP
      - rpc mass activity [client backs up to server]


  Unfortunately, what appears to be happening is a failure at
step 3.  This is because between 2 and 3, the firewall (due to
the RPC conntrack helper) adds an expectation for the actual
RPC procedure call;  server -> client:7937/TCP.  This network
connection does not appear to be available to the RSH 
connection tracker/helper through the conntrack framework.

  Therefore, is it true that expected children connections are
not subjected to the conntrack framework as potential masters,
for other modules?

  Once this "child" connection misses the RSH conntrack helper
the new expected port is not made available and the process
fails.  David has confirmed that by explicitly excluding the
establishment of an expectation for the port 7937/TCP in the
rpc_tcp conntrack helper code, and adding a static rule for
7937/TCP into the filter table, he is able to get the connection
through to the waiting RSH conntrack helper and the whole 
process succeeds.


  Is there a nice way that I can see expectant children 
connections from one module, in another?  (without explicitly
coding for it? -- ie; if Legato code up FTP as an RPC service,
where would we go from there?).




References;

  There are two docs that contain a good deal of technical
information on the Legato networking;

    LEGATO TECHNICAL BULLETIN 354:
    Use of Firewalls with NetWorker® Server Release 5.5 and Later
    http://portal1.legato.com/resources/bulletins/354.html

    David Stes'
    Connection Tracking for Legato NetWorker on Linux
    http://users.pandora.be/stes/nsrfw04.html




Thanks for any assitance rendered,



--
Ian Latter
Internet and Networking Security Officer
Macquarie University
