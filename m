From: 24 <24@k0n.org>
Subject: detecting if compiled or loaded modules
Date: Sun, 15 Dec 2002 13:39:54 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021215133954.70ad328c.24@k0n.org>
References: <20021215053701.15581.32963.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021215053701.15581.32963.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Greets,

     Is there a way to determine if one of the Netfilter Configs is loaded as module or built-in in the
kernel? For example FTP protocol support. Once the system boots or the module is loaded shouldnt it 
create a file somewhere in /proc once the module is up or once the system boots. I'm trying to create
a customized firewall program if it didnt detect the FTP protocol support it will load the module 
or what. Need help...
