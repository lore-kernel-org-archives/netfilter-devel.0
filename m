From: Daimonion <daimonion@misanthropos.de>
Subject: ip_conntrack cleanup on reconnection?
Date: Mon, 05 Jul 2004 15:20:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <opsan10edrkwfgqe@starbug.karlshof.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
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

Hi!

I have a with my DSL uplink reconnects (ppp restart) for kernels with  
higher versions than 2.4.23.
I am using Teamspeak (TS) connected to a public server.
With 2.4.23 I can restart the ppp-connection and my TS-client still keeps  
connected with the TS-server, which
I appreciate. But eversince 2.4.25 or 2.6.x a ppp reconnect disconnects  
the TS-client and I have to reconnect
manually.
Additionally, if I played a game (Enemy Territory) while getting  
disconnected, I can?t reconnect to that
server anymore for a while. It seems like an entry in ip_conntrack  
prevents me from reconnecting (UDP) until
it has timed out.

Any suggestions, or ideas on this one?

Having a look at net/ip_MASQUARDE.c the ip_conntrack list should be empty  
after a device was down (cleanup?), but
the list still is full of entries.
Shouldnt the list be empty or, at least rewritten with the new  
ip-addresses?

Regards,
Richard
