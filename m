From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [ULOG] Fix memory allocation bug - take two
Date: Wed, 18 Jan 2006 18:27:03 +0100
Message-ID: <1137605223893-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: 
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

Hi,

this is resend of my previous patch which fixes a bug in the way 
ULOG does allocate memory.  It uses NLMSG_GOODSIZE to portably
determine the size of 'nlbufsiz'.  Thanks Patrick!

Please apply.

Thanks.  /holger
