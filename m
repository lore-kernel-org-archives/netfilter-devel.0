From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: NF fields in sk_buff
Date: Fri, 30 Jan 2004 17:45:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <401A7C04.8060803@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

I want to send a "built-by-hand" packet on the local hook. In the 
sk_buff structure, there is two fields, nfmark and nfcache, which  I 
don't really understand. Can someone give me a quick briefing on these 
two fields?
Quick search with google made me feel that I don't need them anyway and 
that I can leave them blank. Right?

Bye,
         Emmanuel
