From: Ilguiz Latypov <ilguiz@nit.ca>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Fri, 11 Apr 2003 15:12:58 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304111409550.15504-100000@localhost.localdomain>
References: <3E96F002.5000700@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <3E96F002.5000700@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Friedrich,

On Fri, 11 Apr 2003, Friedrich Lobenstock wrote:

> > If this is true, you would be affected by the modules' rewriting of call
> > IDs in one direction only when you were running the unmodified version.
>
> I don't see a connection to a bad checksum here?

If you were connecting from the Linux NAT box itself without the local NAT
option, then the unmodified connection tracking modules would keep your
connection tracked yet not rewrite the call ID's in replies.

Changing the module to not track bad checksum connections would "fix" the
above issue by relying on bad TCP checksums.

But I understand that this wasn't your case.

The following chart represents my understanding of the PPTP tracking
modules capabilities in their current state.  I assumed that uncommenting
the "return NF_ACCEPT" statement in question is equivalent to not tracking
a connection with bad TCP checksum.

One can see from that chart that not tracking bad checksum connections
will only benefit the "no local NAT support, connection from the NAT box,
bad checksum"  scenario.  On the other hand, in case of connections from
behind the NAT box, the suggested change will prevent from more than one
bad checksum connection at a time.

The current decision to keep that statement commented means the latter
case casualty outweighed the advantages of the former case in the author's
mind.

I don't understand how the change helped you in the latter case while
theoretically it should only make things worse there.

Thanks,

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117


                                 connection from       connection from
                               behind the NAT box    the NAT box itself

                               good TCP   bad TCP     good TCP   bad TCP
                               checksum   checksum    checksum   checksum


      no PPTP modules             1          1           +          +


   unmodified PPTP modules        +          +           -          -
 without the local NAT option

   unmodified PPTP modules        +          +           +          +
  with the local NAT option

 uncommented "return NF_ACCEPT"
    for bad TCP checksums         +          1           -          +
 without the local NAT option

 uncommented "return NF_ACCEPT"
    for bad TCP checksums         +          1           +          +
  with the local NAT option


------------------
+: Any number of connections of given class is treated correctly.
-: No connection possible.
1: Only one connection at a time will work in these cases.  If this refers
   to the "behind the NAT box" connections, no connections from the NAT
   box itself should be allowed for this to work.
