From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: Re: TCP window tracking has bad side effects
Date: Wed, 1 Dec 2004 16:39:03 +0100
Message-ID: <20041201153903.GA16807@suse.de>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
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


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Jozsef Kadlecsik wrote:
> On Wed, 1 Dec 2004, Ludwig Nussel wrote:
> > With TCP window tracking those rules no longer work for services
> > that use fixed ports (e.g. NFS) and one side crashes or terminates
> > the connection in other ways without notifying the peer (e.g. link
> > down). When the crashed machine comes up again and tries to
> > reestablish the connection it sends a SYN. The remote end finds that
> > confusing and replies with an ACK as probe. Since that ACK does not
> > fit any window it's discarded as INVALID.
> 
> The remote end must send an ACK segment which is in the window (see
> RFC793, p68), thus the window tracking code could let it through.

My description probably wasn't unambiguous. The client has the
packetfilter, crashes and reboots. The server does not notice and
just sees an out of sequence SYN for an existing connection (same
ip/port). The server responds with an ACK which contains the
sequence numbers it expects for that connection (p36 in above cited
rfc). On the client side this ACK does not belong to the SYN it sent
and is discarded whereas it should be answered with RST.

> > The remote side can now
> > sit there forever sending ACKs and no new connection can be
> > established. Previously, without window tracking, the ACK was
> > accepted and answered with RST, the remote closed the connection and
> > a new one could be established.
> >
> > Is there a way to disable the window tracking and revert to the old
> > behavior?
> 
> Yes, you can disable it anytime:
> 
> echo 1 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal

Doesn't help.

> But a full tcpdump from such a session and the log entries on the
> invalid packets would be useful for us to recheck the code.

tcpdump file attached. 192.168.42.1 is the server and 192.168.42.2
the client with packetfilter.

The log of a dropped ACK packet looks like this:

SRC=192.168.42.1 DST=192.168.42.2 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=26022 DF PROTO=TCP SPT=9999 DPT=8888 WINDOW=1448 RES=0x00 ACK URGP=0 OPT (0101080A015EB588FFFD6ED1)

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   SUSE LINUX Products GmbH, Development
 V_/_  http://www.suse.de/

--UlVJffcvxoiEqYs2
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=tcpdump46818
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAP//AAABAAAArOGtQbiZCABKAAAASgAAAAACpV4tSgBQ/ImhJwgA
RQAAPHbCQABABu6lwKgqAsCoKgEiuCcPdBUVEQAAAACgAhbQJSIAAAIEBbQEAggK//1j0wAA
AAABAwMCrOGtQR+aCABKAAAASgAAAABQ/ImhJwACpV4tSggARQAAPAAAQABABmVowKgqAcCo
KgInDyK4jp8e1nQVFRKgEhag+v8AAAIEBbQEAggKAVV7dv/9Y9MBAwMCrOGtQd+ZCABCAAAA
QgAAAAACpV4tSgBQ/ImhJwgARQAANHbDQABABu6swKgqAsCoKgEiuCcPdBUVEo6fHteAEAW0
OrMAAAEBCAr//WPTAVV7dq/hrUEPvgUASwAAAEsAAAAAAqVeLUoAUPyJoScIAEUAAD12xEAA
QAbuosCoKgLAqCoBIrgnD3QVFRKOnx7XgBgFtBiPAAABAQgK//1u0QFVe3ZERUFEQkVFRgqv
4a1BSr4FAEIAAABCAAAAAFD8iaEnAAKlXi1KCABFAAA0ZaFAAEAG/87AqCoBwKgqAicPIriO
nx7XdBUVG4AQBagkuwAAAQEICgFVhnP//W7RWuKtQVYGDQBKAAAASgAAAAACpV4tSgBQ/Imh
JwgARQAAPDERQABABjRXwKgqAsCoKgEiuCcPft4PswAAAACgAhbQROgAAAIEBbQEAggK//0+
ogAAAAABAwMCWuKtQYUGDQBCAAAAQgAAAABQ/ImhJwACpV4tSggARQAANGWiQABABv/NwKgq
AcCoKgInDyK4jp8e13QVFRuAEAWohskAAAEBCAoBWCRi//1u0V3irUH+/wwASgAAAEoAAAAA
AqVeLUoAUPyJoScIAEUAADwxEkAAQAY0VsCoKgLAqCoBIrgnD37eD7MAAAAAoAIW0DkwAAAC
BAW0BAIICv/9SloAAAAAAQMDAl3irUErAA0AQgAAAEIAAAAAUPyJoScAAqVeLUoIAEUAADRl
o0AAQAb/zMCoKgHAqCoCJw8iuI6fHtd0FRUbgBAFqHsSAAABAQgKAVgwGf/9btFj4q1BZvoM
AEoAAABKAAAAAAKlXi1KAFD8iaEnCABFAAA8MRNAAEAGNFXAqCoCwKgqASK4Jw9+3g+zAAAA
AKACFtAhwAAAAgQFtAQCCAr//WHKAAAAAAEDAwJj4q1BoPoMAEIAAABCAAAAAFD8iaEnAAKl
Xi1KCABFAAA0ZaRAAEAG/8vAqCoBwKgqAicPIriOnx7XdBUVG4AQBahjowAAAQEICgFYR4j/
/W7R

--UlVJffcvxoiEqYs2--
