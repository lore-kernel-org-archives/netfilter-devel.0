From: "andre achternaam" <andreiscmeel@hotmail.com>
Subject: ip_conntrack_expect_related() cannot handle already established connections
Date: Wed, 25 Sep 2002 06:33:05 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F118F3bhFovvrhtyXMl00005bde@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi all,

I have some difficulties with my Nat/connection tracking module that is very 
similar like the ftp one.

My setup up:

I have a server that sends streams (UDP packets) to clients. Between the 
clients and the server a gateway is located. The gateway is configured with 
all the masquerade stuff you would expect.
>From the gateway point of view the server streams are coming form the 
external site. The streams are a result from another (master/control) 
connection. The same way it is for ftp. The only difference is the expected 
connection is a UDP stream and not a TCP stream.

My conntrack/NAT module looks very similar like the ftp one and works file 
for one client and even for two clients behind the gateway. But it works 
only properly when the clients specify their "port command (where to receive 
the UDP stream)" differently thus not the same. However I understand that 
the ftp module can handle the same port numbers, by mangling the outgoing 
"port command" (Doing NAPT). I also implemented this in my module.

When I register an expected related connection it mostly uses the 
"ctMyInfo->portOrg" port since it is free and sometimes another number when 
in use.

…
memset(&tuple, 0, sizeof(tuple));
tuple.dst.ip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip;
tuple.dst.protonum = IPPROTO_UDP;
/* Try to get same port: if not, try to change it. */
for (port = ctMyInfo->portOrg; port != 0; port++)
{
    tuple.dst.u.udp.port = htons(port);
    if (ip_conntrack_expect_related(ct, &tuple, &mask, NULL) == 0)
        break;
}
…

When a packet of the expected_related connection comes in and the entry is 
removed from the expect_list in the init_conntrack function.

…. Init_conntrack(…)
…
    if (expected && is_confirmed(expected->expectant)) {
        /* Welcome, Mr. Bond.  We've been expecting you... */
       conntrack->status = IPS_EXPECTED;
       conntrack->master.master = &expected->expectant->ct_general;
       IP_NF_ASSERT(conntrack->master.master);
       LIST_DELETE(&expect_list, expected);
       MyDebugPrint(expected, "LIST_DELETED(init_conntrack)");
       expected->expectant = NULL;
       nf_conntrack_get(&conntrack->master);
    }
….
}

Oke now it is removed from the expect_list but what if I register a new 
expected connection with ip_conntrack_expect_related() function and with the 
same port number as the previous one. The previous one is still in use by my 
previously started UDP stream but it can be registered as well since the 
init_conntrack() function removed this expected connection from the 
expect_list and the ip_conntrack_expect_related() will only look in the 
expected list.

Here is the question:

Why is it also not checking the existing (established) connections to see if 
this port number/ipaddress combination is in use? At the moment I'am able to 
register expected related connections that are in use. This might be by 
designs but is this an bug in the ftp (and thus my modules as wel)?

And how can I figure out if the expected connection is in use by something 
else. It seems that checking the return value of 
ip_conntrack_expect_related() is not enough because it only looks in the 
expected_list of connections you expect….


Thanx in advance for all the effort…
Andre



_________________________________________________________________
Chat with friends online, try MSN Messenger: http://messenger.msn.com
