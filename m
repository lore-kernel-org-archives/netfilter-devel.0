From: Bart <b-m@pandora.be>
Subject: conntrack question
Date: Thu, 09 Jan 2003 14:04:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1D7361.8030400@myland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

E.g. if I want to monitor connections to an FTP-server, I would register 
a helper
with destination-port set to 21, but this ain't the way it works, 
because I saw that
the ftp/irc contrack helpers register a helper with a source port set,
why ?


Tnx,
greetz
