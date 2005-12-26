From: Pedrito <petermartx@yahoo.es>
Subject: ip nat ftp possible client port clash
Date: Mon, 26 Dec 2005 16:28:25 +0100
Message-ID: <43B00C19.8040609@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi everybody, I think there may be a port clash problem with the ip nat 
ftp conntrack code, I will try to explain it with a very simple scenario:

- Two PCs with IPs 192.168.1.1 and 192.168.1.2
- Both PCs go to internet through a linux router box with external IP 
80.1.1.1, internal IP 192.168.1.3.
- There is an external ftp server with IP 81.1.1.1

Imagine the client with IP 192.168.1.1 which is below the linux router 
box is happily downloading a file from the ftp 81.1.1.1 using local port 
1025, which is natted to port 1025 because the ftp nat core tries to 
preserve the local port. So there is a connection stablished like that:
 Original  81.1.1.1:20 -> 80.1.1.1:1025  Replay 
192.168.1.1:1025->81.1.1.1:20

 Then the other client with IP 192.168.1.2 wants to stablish a data 
connection with the same server, and unfortunately the operating system 
of this PC also chooses port 1025 to stablish the connection. The ftp 
nat conntrack code will try to preserve the local port and will also 
choose port 1025 for this connection. Then the answer for the connection 
tcp syn packet for the server will be 81.1.1.20->80.1.1.1:1025 and this 
packet matches the previously created client 1 connection, so the syn 
packet will be forwarded to PC1, not to PC2!!

This is the code that chooses the ftp external port:

    /* Try to get same port: if not, try to change it. */
    for (port = ntohs(exp->saved_proto.tcp.port); port != 0; port++) {
        exp->tuple.dst.u.tcp.port = htons(port);
        if (ip_conntrack_expect_related(exp) == 0)
            break;
    }
Note that PC1 client connection is not expected, PC1 is already 
downloading the file from the server so ip_conntrack_expect_related will 
not find the connection in the expected list...

I am sure I am missing something in the conntrack ftp code that prevents 
that from happening, but I cannot find it, any help?

Best Regards, Pedro. (sorry for my poor english, I am spanish...)

		
______________________________________________ 
Renovamos el Correo Yahoo! 
Nuevos servicios, más seguridad 
http://correo.yahoo.es
