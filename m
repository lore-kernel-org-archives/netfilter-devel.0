From: Thomas Heinz <creatix@hipac.org>
Subject: Re: developing netfilter patch
Date: Sat, 25 Jan 2003 11:32:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E3267A9.3000006@hipac.org>
References: <4664598217.20030125054359@yahoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: macadanet@yahoo.es
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Macada

You wrote:
> My great trouble is that my patch has a libipt_name.c in
> /usr/src/netfilter/userspace/extensions/.
> 
> I don't known add it to the makefile to create libipt_name.so (shared
> object) in /lib/iptables/.

You probably forgot to create a test userspace/extensions/.name-test
for your extension (as described in patch-o-matic/NEWPATCHES).

The reason that this test is needed becomes obvious when you look
at userspace/extensions/Makefile. In line 12 it says:
PF_EXT_SLIB_OPTS:=$(foreach T,$(wildcard extensions/.*-test),$(shell 
KERNEL_DIR=$(KERNEL_DIR) $(T)))

Now, if there is no userspace/extensions/.name-test your extensions
is not part of PF_EXT_SLIB_OPTS which means that no libipt_name.so
will be built. Moreover if userspace/extensions/.name-test does not
output name (as above 'name' stands for the name of your extension)
which should be the case if the corresponding kernel patch was not
applied your extension will also not become part of PF_EXT_SLIB_OPTS.

Just take a look at existing userspace/extensions/.*-test files.


Hope that helps.

Thomas
