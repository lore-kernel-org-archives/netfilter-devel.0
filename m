From: Juha Heljoranta <juha.heljoranta@evitech.fi>
Subject: stat module
Date: 11 Nov 2003 12:49:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1068547747.1719.114.camel@jazz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hi, 

I was thinking about to write a module to match outbound packets against
stat (file of filesystem status) information. One might find device and
inode information usefull.

Usage might be something like
$ iptables -A OUTPUT -m stat --device 303 --inode 341166 -j ACCEPT

Anyway, I thought to ask if you have any suggestions, thoughts,
opinions, etc. about this. I might find them helpfull :)

I have about 400 hours to spend on this. So how does it sound? 


Regards,

Juha Heljoranta
email: juha.heljoranta at evitech.fi
