From: "Saber zrelli" <saber_z@fastmail.fm>
Subject: Netfilter based application : any advice ?
Date: Mon, 15 Mar 2004 06:44:30 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1079300670.3068.182659007@webmail.messagingengine.com>
References: <200403141930.29602.alchemyx@uznam.net.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200403141930.29602.alchemyx@uznam.net.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi people ,

i'm new in Netfilter community ,
I'm planning to crate a network software robot acting like 'automata'
based on scripts dicting its behaviour .
i explain :

the main program basically filter packets and executes actions like
iptbles does ,  based on rules located in some file.
the difference is that the actions can also be sending specific packet.
the tool should allows for example simulation of tcp/ip connections , ftp
connections and so on.

the implentation will consist on a Netfilter module that will be added to
hook on the network activities.
now the point is :

- Is it possible to send packets with Netfilter or not? ( if not i guess
using libnet will resolve the pb but better to have  
  every thing based on the same infrastructure)

- I would like to have the tool work with wireless protocol , does
Netfilter support non Ethernet proto and 802.11 particulary?


any advices will be really appreciated.
also , any partner for the project is welcome.

Regards.

-- 
  Saber Zrelli
  kanazawa university international house 
  kakuma-machi , kanazawa , Ishikawa 
  920-1192 Japan. 
