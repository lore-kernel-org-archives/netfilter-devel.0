From: Guillowind@aol.com
Subject: Re: string patch for 2.6
Date: Sat, 01 Jan 2005 18:25:14 -0500
Message-ID: <0AD52117.79752AB5.0B9ABE5A@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Guillowind@aol.com, jnk@pwn.emphyrio.org (Dimitris Kotsonis),
	netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Ok, sorry for the spam/confusion

I made another directory called linux-2.6 in the string directory and copied the files from the linux dir into it then edited the patch to leave out the editing of string/info as it already appeared to have that information, then repatched with patch -p1 < ../kernel-2.6-string patch and there were no errors.

I ran a make menuconfig for the kernel dir (2.6.10) and it was there, so now Im building the RPMS, Thanks!

Brian Urrutia
RHCE
