From: Oscar Mechanic <oscar@ufomechanic.net>
Subject: libnetfilter-queue
Date: Thu, 03 May 2007 20:13:07 +0100
Message-ID: <1178219587.4261.31.camel@OSCARLAPLIN>
Reply-To: oscar@ufomechanic.net
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi

    can anyone point me in the right direction for how to learn how to
rewrite the packet using libnetfilter and then inject it. Is it as
simple as grabbing the buffer from "nfq_get_payload" changing this and
then setting the verdict, surely not. I know the checksums have to be
changed then.

If someone has an example that would be great. I have been all around
netfilter/google/sourceforge/freshmeat and I still could not find any
info.

Thanks
Oscar
