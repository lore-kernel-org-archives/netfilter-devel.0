From: "Intrepid One" <trep@linuxmail.org>
Subject: MAPI RPC Packet Filtering Dream
Date: Mon, 10 Feb 2003 12:51:32 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030210185132.6026.qmail@linuxmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am migrating a clients servers to linux with the exception of their MS Exchange 5.5 Server (will probably migrate to 2000).  That is all fine and good, and in itself a hard enough thing to do (single login, shared user/password list b/t linux&Exchange), but they also want to connect to Exchange through the internet, (not using web based email).
This opens up port 135, and anyone with experience in MS crapsecure software knows that opening that port is a stupid thing to do.  I could do the VPN thing, but do I really want to ?
In searching/studying I stumbled on to an article that talks about this very thing, but it involves using MS ISA, w/ch I will not use.  The server side of this company will be all linux & open-source, w/ the exception of exchange.  Please do not flame me for using MS software, the use is not by choice, it is what a client has and I must work around it and wrap linux as tight around it as I can.
I included some of the text from the article.  I believe what ISA is described as doing in the article is, at current, an impossible thing to do with anything but MS software (b/c it utilizes MAPI/RPC and, as we all know, MS will not disclose MAPI & RPC innerworkings).  So if it is impossible, just say so. I am just dreaming that there is a way to do it without ISA.  If my dream is crushed then I will use a VPN or something.  Recommendations would be nice, except those that say 'get rid of ms exchange'.  I would if I could.

--Section of Article--
Included with ISA is an Exchange RPC filter rule. This is a special packet filter that protects your servers from external attacks by first inspecting the packets and then proxying them onto the correct Exchange server. Basically, this is how it works :-

When a MAPI client tries to make a connection to an Exchange server (behind an ISA server using the Exchange RPC filter rule), it's first point of contact is the ISA server. The RPC packet it sends contains a MAPI data portion. ISA then inspects the packet to ensure it is a valid RPC packet. If the RPC packet is destined for the Exchange server, and contains the proper MAPI portion in the packet, otherwise called an Exchange MAPI RPC packet, it is then sent to the Exchange server by the ISA server on behalf of the client. Or in other words, a proxied request. Any other RPC packets are blocked.
--End--

Thanks
--
Trep
-- 
______________________________________________
http://www.linuxmail.org/
Now with e-mail forwarding for only US$5.95/yr

Powered by Outblaze
